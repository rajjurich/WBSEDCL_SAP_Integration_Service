using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;


namespace SAPIntegrationServiceClient.Common
{
    public sealed class AccessClient
    {
        private static readonly Lazy<AccessClient> instance = new Lazy<AccessClient>(() => new AccessClient());
        private WebClient client; 
        private AccessClient()
        {
            client = new WebClient();
        }
        public static AccessClient GetInstance
        {
            get
            {
                return instance.Value;
            }
        }

        public WebClient GetClient()
        {
            return client;
        }
    }    
}
