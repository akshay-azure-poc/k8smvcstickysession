using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MVCStickSession.Controllers
{
    public class PodDetailsController : ApiController
    {
        [HttpGet]
        // POST: api/PodDetails
        public string GetMachineInformation()
        {
            string _env = string.Empty;

            _env = string.Format("Machine Name: {0}, OS Version: {1}, ProcessCount: {2}",
                System.Environment.MachineName, System.Environment.OSVersion.ToString(), 
                System.Environment.ProcessorCount.ToString());
            return _env;
        }
    }
}
