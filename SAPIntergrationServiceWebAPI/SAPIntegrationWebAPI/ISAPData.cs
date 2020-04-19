using SAPIntegrationWebAPI.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SAPIntegrationWebAPI
{
    public interface ISAPData
    {
        int GetSAPData(Logs logs, SQLHelperClass helper);
    }
}
