using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using MVCStickSession.Models;

namespace MVCStickSession.Controllers
{
    public class StickyController : ApiController
    {
        static Sticky _Sticky = new Sticky { email = "Not set", id = 0, name = "Not set", phone = "Not set" };

        // GET: api/Sticky
        [ResponseType(typeof(Sticky))]
        public Sticky Get()
        {
            return _Sticky;
        }

        // POST: api/Sticky
        public void Post(Sticky value)
        {
            _Sticky = new Sticky { email = value.email, id = value.id, name = value.name, phone = value.phone };
        }

        // DELETE: api/Sticky
        public void Delete()
        {
            _Sticky = null;
        }
    }
}
