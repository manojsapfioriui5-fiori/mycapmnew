module.exports = cds.service.impl(async function () {
    const { EmployeeSet, POs } = this.entities;
//generic handlers
    this.before(['UPDATE', 'CREATE'], EmployeeSet, (req, res) => {
        var jsonData = req.data;
        if (jsonData.hasOwnProperty("salaryAmount")) {
            if (jsonData.salaryAmount > 90000) {
                const salary = parseFloat(jsonData.salaryAmount);
                if (salary > 90000) {
                    req.error(500, "Salary amount should not be greater than 90000");
                }
            }
        }
    });
    this.after("READ", EmployeeSet, (req, res) => {
        var results = res.results;
        results.push({
            "ID": "Dummy",
            "nameFirst": "Akhil"
        })
    });
    //Actions and Functions
    this.on('getMostExpensiveOrder', async (req, res) => {
        try {
            const result = await cds.tx(req).run(
                SELECT.from(POs).orderBy('GROSS_AMOUNT desc').limit(1));
            return result;
        } catch (error) {
            return Promise.reject(new Error("Error fetching most expensive product: " + error.message));
        }
    });

    //instance bound action
    this.on("boost", async (req, res) => {
        try {
            //programatically check @runtime if user have required permissions
            req.user.is('Editor') || req.reject(403)
            const POID = req.params[0]; // Assuming the ID is passed as a parameter in the request
            await cds.tx(req).run(
                UPDATE(POs).with({ GROSS_AMOUNT: { '+=': 20000 } }).where(POID)
            );
            // after modify, read the instance
            const reply = cds.tx(req).read(POs).where(POID);
            return reply;
        } catch (error) {

        }
    });
})

