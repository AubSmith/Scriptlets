﻿// Copyright (c) Microsoft Corporation.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using System;
using System.Collections.Generic;
#if !CORECLR
using System.ComponentModel.Composition;
#endif
using System.Globalization;
using System.Linq;
using System.Management.Automation.Language;
using Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic;

namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.BuiltinRules
{
    /// <summary>
    /// A class to walk an AST to check for violation.
    /// </summary>
#if !CORECLR
    [Export(typeof(IScriptRule))]
#endif
    public class UseConsistentIndentation : ConfigurableRule
    {
        /// <summary>
        /// The indentation size in number of space characters.
        ///
        /// Default value if 4.
        /// </summary>
        [ConfigurableRuleProperty(defaultValue: 4)]
        public int IndentationSize { get; protected set; }

        private enum IndentationKind { Space, Tab };

        // TODO make this configurable
        private readonly IndentationKind indentationKind = IndentationKind.Space;

        /// <summary>
        /// Analyzes the given ast to find violations.
        /// </summary>
        /// <param name="ast">AST to be analyzed. This should be non-null</param>
        /// <param name="fileName">Name of file that corresponds to the input AST.</param>
        /// <returns>A an enumerable type containing the violations</returns>
        public override IEnumerable<DiagnosticRecord> AnalyzeScript(Ast ast, string fileName)
        {
            if (ast == null)
            {
                throw new ArgumentNullException("ast");
            }

            // we add this switch because there is no clean way
            // to disable the rule by default
            if (!Enable)
            {
                return Enumerable.Empty<DiagnosticRecord>();
            }

            var tokens = Helper.Instance.Tokens;
            var diagnosticRecords = new List<DiagnosticRecord>();
            var indentationLevel = 0;
            var onNewLine = true;
            for (int k = 0; k < tokens.Length; k++)
            {
                var token = tokens[k];

                if (token.Kind == TokenKind.EndOfInput)
                {
                    break;
                }

                switch (token.Kind)
                {
                    case TokenKind.AtCurly:
                    case TokenKind.AtParen:
                    case TokenKind.LParen:
                    case TokenKind.LCurly:
                    case TokenKind.DollarParen:
                        AddViolation(token, indentationLevel++, diagnosticRecords, ref onNewLine);
                        break;

                    case TokenKind.RParen:
                    case TokenKind.RCurly:
                        indentationLevel = ClipNegative(indentationLevel - 1);
                        AddViolation(token, indentationLevel, diagnosticRecords, ref onNewLine);
                        break;

                    case TokenKind.NewLine:
                    case TokenKind.LineContinuation:
                        onNewLine = true;
                        break;

                    default:
                        // we do not want to make a call for every token, hence
                        // we add this redundant check
                        if (onNewLine)
                        {
                            var tempIndentationLevel = indentationLevel;

                            // Check if the preceding character is an escape character
                            if (k > 0 && tokens[k - 1].Kind == TokenKind.LineContinuation)
                            {
                                ++tempIndentationLevel;
                            }
                            else
                            {
                                // Ignore comments
                                // Since the previous token is a newline token we start
                                // looking for comments at the token before the newline token.
                                int j = k - 2;
                                while (j > 0 && tokens[j].Kind == TokenKind.Comment)
                                {
                                    --j;
                                }

                                if (j >= 0 && tokens[j].Kind == TokenKind.Pipe)
                                {
                                    ++tempIndentationLevel;
                                }
                            }

                            AddViolation(token, tempIndentationLevel, diagnosticRecords, ref onNewLine);
                        }
                        break;
                }
            }

            return diagnosticRecords;
        }

        /// <summary>
        /// Retrieves the common name of this rule.
        /// </summary>
        public override string GetCommonName()
        {
            return string.Format(CultureInfo.CurrentCulture, Strings.UseConsistentIndentationCommonName);
        }

        /// <summary>
        /// Retrieves the description of this rule.
        /// </summary>
        public override string GetDescription()
        {
            return string.Format(CultureInfo.CurrentCulture, Strings.UseConsistentIndentationDescription);
        }

        /// <summary>
        /// Retrieves the name of this rule.
        /// </summary>
        public override string GetName()
        {
            return string.Format(
                CultureInfo.CurrentCulture,
                Strings.NameSpaceFormat,
                GetSourceName(),
                Strings.UseConsistentIndentationName);
        }

        /// <summary>
        /// Retrieves the severity of the rule: error, warning or information.
        /// </summary>
        public override RuleSeverity GetSeverity()
        {
            return RuleSeverity.Warning;
        }

        /// <summary>
        /// Gets the severity of the returned diagnostic record: error, warning, or information.
        /// </summary>
        /// <returns></returns>
        public DiagnosticSeverity GetDiagnosticSeverity()
        {
            return DiagnosticSeverity.Warning;
        }

        /// <summary>
        /// Retrieves the name of the module/assembly the rule is from.
        /// </summary>
        public override string GetSourceName()
        {
            return string.Format(CultureInfo.CurrentCulture, Strings.SourceName);
        }

        /// <summary>
        /// Retrieves the type of the rule, Builtin, Managed or Module.
        /// </summary>
        public override SourceType GetSourceType()
        {
            return SourceType.Builtin;
        }

        private void AddViolation(
            Token token,
            int expectedIndentationLevel,
            List<DiagnosticRecord> diagnosticRecords,
            ref bool onNewLine)
        {
            if (onNewLine)
            {
                onNewLine = false;
                if (token.Extent.StartColumnNumber - 1 != GetIndentation(expectedIndentationLevel))
                {
                    var fileName = token.Extent.File;
                    var extent = token.Extent;
                    var violationExtent = extent = new ScriptExtent(
                        new ScriptPosition(
                            fileName,
                            extent.StartLineNumber,
                            1, // first column in the line
                            extent.StartScriptPosition.Line),
                        new ScriptPosition(
                            fileName,
                            extent.StartLineNumber,
                            extent.StartColumnNumber,
                            extent.StartScriptPosition.Line));
                    diagnosticRecords.Add(
                        new DiagnosticRecord(
                            String.Format(CultureInfo.CurrentCulture, Strings.UseConsistentIndentationError),
                            violationExtent,
                            GetName(),
                            GetDiagnosticSeverity(),
                            fileName,
                            null,
                            GetSuggestedCorrections(token, expectedIndentationLevel)));
                }
            }
        }

        private List<CorrectionExtent> GetSuggestedCorrections(
            Token token,
            int indentationLevel)
        {
            // TODO Add another constructor for correction extent that takes extent
            // TODO handle param block
            // TODO handle multiline commands

            var corrections = new List<CorrectionExtent>();
            corrections.Add(new CorrectionExtent(
                token.Extent.StartLineNumber,
                token.Extent.EndLineNumber,
                1,
                token.Extent.EndColumnNumber,
                GetIndentationString(indentationLevel) + token.Extent.Text,
                token.Extent.File));
            return corrections;
        }

        private static int ClipNegative(int x)
        {
            return x > 0 ? x : 0;
        }

        private int GetIndentationColumnNumber(int indentationLevel)
        {
            return GetIndentation(indentationLevel) + 1;
        }

        private int GetIndentation(int indentationLevel)
        {
            return indentationLevel * this.IndentationSize;
        }

        private char GetIndentationChar()
        {
            return indentationKind == IndentationKind.Space ? ' ' : '\t';
        }

        private string GetIndentationString(int indentationLevel)
        {
            return new string(GetIndentationChar(), GetIndentation(indentationLevel));
        }
    }
}
