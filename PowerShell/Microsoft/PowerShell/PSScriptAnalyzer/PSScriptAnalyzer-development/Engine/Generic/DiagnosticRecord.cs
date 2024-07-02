﻿//
// Copyright (c) Microsoft Corporation.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//



using System;
using System.Collections.Generic;
using System.Management.Automation.Language;

namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
{
    /// <summary>
    /// Represents a result from a PSScriptAnalyzer rule.
    /// It contains a message, extent, rule name, and severity.
    /// </summary>
    public class DiagnosticRecord
    {
        private string message;
        private IScriptExtent extent;
        private string ruleName;
        private DiagnosticSeverity severity;
        private string scriptPath;
        private string ruleSuppressionId;
        private List<CorrectionExtent> suggestedCorrections;

        /// <summary>
        /// Represents a string from the rule about why this diagnostic was created.
        /// </summary>
        public string Message
        {
            get { return message; }
            protected set { message = string.IsNullOrEmpty(value) ? string.Empty : value; }
        }

        /// <summary>
        /// Represents a span of text in a script.
        /// </summary>
        public IScriptExtent Extent
        {
            get { return extent; }
            protected set { extent = value; }
        }

        /// <summary>
        /// Represents the name of a script analyzer rule.
        /// </summary>
        public string RuleName
        {
            get { return ruleName; }
            protected set { ruleName = string.IsNullOrEmpty(value) ? string.Empty : value; }
        }

        /// <summary>
        /// Represents a severity level of an issue.
        /// </summary>
        public DiagnosticSeverity Severity
        {
            get { return severity; }
            set { severity = value; }
        }

        /// <summary>
        /// Represents the name of the script file that is under analysis
        /// </summary>
        public string ScriptName
        {
            get { return string.IsNullOrEmpty(scriptPath) ? string.Empty : System.IO.Path.GetFileName(scriptPath);}
        }

        /// <summary>
        /// Returns the path of the script.
        /// </summary>
        public string ScriptPath
        {
            get { return scriptPath; }
            protected set { scriptPath = string.IsNullOrEmpty(value) ? string.Empty : value; }
        }

        /// <summary>
        /// Returns the rule id for this record
        /// </summary>
        public string RuleSuppressionID
        {
            get { return ruleSuppressionId; }
            set { ruleSuppressionId = value; }
        }

        /// <summary>
        /// Returns suggested correction
        /// return value can be null
        /// </summary>
        public IEnumerable<CorrectionExtent> SuggestedCorrections
        {
            get { return suggestedCorrections;  }            
        }

        /// <summary>
        /// DiagnosticRecord: The constructor for DiagnosticRecord class.
        /// </summary>
        public DiagnosticRecord()
        {

        }
        
        /// <summary>
        /// DiagnosticRecord: The constructor for DiagnosticRecord class that takes in suggestedCorrection
        /// </summary>
        /// <param name="message">A string about why this diagnostic was created</param>
        /// <param name="extent">The place in the script this diagnostic refers to</param>
        /// <param name="ruleName">The name of the rule that created this diagnostic</param>
        /// <param name="severity">The severity of this diagnostic</param>
        /// <param name="scriptPath">The full path of the script file being analyzed</param>
        /// <param name="suggestedCorrections">The correction suggested by the rule to replace the extent text</param>
        public DiagnosticRecord(string message, IScriptExtent extent, string ruleName, DiagnosticSeverity severity, string scriptPath, string ruleId = null, List<CorrectionExtent> suggestedCorrections = null)
        {
            Message  = message;
            RuleName = ruleName;
            Extent   = extent;
            Severity = severity;
            ScriptPath = scriptPath;
            RuleSuppressionID = ruleId;
            this.suggestedCorrections = suggestedCorrections;
        }

    }


    /// <summary>
    /// Represents a severity level of an issue.
    /// </summary>
    public enum DiagnosticSeverity : uint
    {
        /// <summary>
        /// Information: This diagnostic is trivial, but may be useful.
        /// </summary>
        Information   = 0,

        /// <summary>
        /// WARNING: This diagnostic may cause a problem or does not follow PowerShell's recommended guidelines.
        /// </summary>
        Warning  = 1,

        /// <summary>
        /// ERROR: This diagnostic is likely to cause a problem or does not follow PowerShell's required guidelines.
        /// </summary>
        Error    = 2,
    };
}
