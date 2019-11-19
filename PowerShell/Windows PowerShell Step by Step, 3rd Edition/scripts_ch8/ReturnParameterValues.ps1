function MyFunction ($param1, $param2)
{
    switch ($MyInvocation.BoundParameters.Keys)
    {
     "param1" {"param1 is $param1" }
     "param2" {"param2 is $param2" }
     }
}
