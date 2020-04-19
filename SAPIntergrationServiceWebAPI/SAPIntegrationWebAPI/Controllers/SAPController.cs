using SAPIntegrationWebAPI.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SAPIntegrationWebAPI.Controllers
{
    public class SAPController : ApiController
    {
        private ISAPData _iSAPData;
        private Logs _logs;
        private SQLHelperClass _helper;
        public SAPController()
        {
            _iSAPData = SAPData.GetInstance;
            _logs = Logs.GetInstance;
            _helper = SQLHelperClass.GetInstance;
        }

        // GET api/sap
        public string Get()
        {
            var val = _iSAPData.GetSAPData(_logs, _helper);
            return val.ToString();
        }

        // GET api/sap/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/sap
        public void Post([FromBody]string value)
        {
        }

        // PUT api/sap/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/sap/5
        public void Delete(int id)
        {
        }
    }
}
