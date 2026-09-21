using { manoj.db.master } from '../db/data-model';

service MyService{
    function helloWorld(input:String(20)) returns String;
    entity EmployeeSrv as projection on master.employees;
}