using SAP.Middleware.Connector;
using SAPIntegrationWebAPI.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SAPIntegrationWebAPI
{
    public class ECCDestinationConfig : IDestinationConfiguration
    {
        public bool ChangeEventsSupported()
        {
            return false;
        }

        public event RfcDestinationManager.ConfigurationChangeHandler ConfigurationChanged;

        public RfcConfigParameters GetParameters(string destinationName)
        {

            RfcConfigParameters parms = new RfcConfigParameters();

            if (destinationName.Equals("mySAPdestination"))
            {
                parms.Add(RfcConfigParameters.AppServerHost, GenericFunctions.AppServerHost);
                parms.Add(RfcConfigParameters.SystemNumber, GenericFunctions.SystemNumber);
                parms.Add(RfcConfigParameters.SystemID, GenericFunctions.SystemID);
                parms.Add(RfcConfigParameters.User, GenericFunctions.SapUser);
                parms.Add(RfcConfigParameters.Password, GenericFunctions.SapPassword);
                parms.Add(RfcConfigParameters.Client, GenericFunctions.Client);
                parms.Add(RfcConfigParameters.Language, "EN");
                parms.Add(RfcConfigParameters.PoolSize, "5");
                parms.Add(RfcConfigParameters.MaxPoolSize, "10");
                parms.Add(RfcConfigParameters.IdleTimeout, "60");

            }
            return parms;

        }
    }
}