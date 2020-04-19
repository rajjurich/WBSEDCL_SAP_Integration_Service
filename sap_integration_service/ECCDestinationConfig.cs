using SAP.Middleware.Connector;
using sap_integration_service.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace sap_integration_service
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
                parms.Add(RfcConfigParameters.PeakConnectionsLimit, "10");
                parms.Add(RfcConfigParameters.IdleTimeout, "600");

            }
            return parms;

        }
    }
}
