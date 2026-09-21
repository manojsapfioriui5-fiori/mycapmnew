const cds = require('@sap/cds');
const { employees }  = cds.entities('manoj.db.master');
module.exports = (srv) => {
    const { EmployeeSrv } = srv.entities;
    srv.on("helloWorld", (req,res) => {
        return "Hello " + req.data.input;
    });
      srv.on('READ', "EmployeeSrv", async (req, res) => {
        try {
            result = await cds.tx(req).run(
                SELECT.from(employees).where(
                    {
                        "salaryAmount": { '>': 90000 }
                    }
                )
            );
            return result;
        } catch (error) {
            return Promise.reject(new Error("Error fetching employees: " + error.message));
        }
    });
}