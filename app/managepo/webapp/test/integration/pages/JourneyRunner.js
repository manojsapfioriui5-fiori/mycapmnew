sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"cutomer/po/managepo/test/integration/pages/POsList.gen",
	"cutomer/po/managepo/test/integration/pages/POsObjectPage.gen",
	"cutomer/po/managepo/test/integration/pages/POItemsObjectPage.gen"
], function (JourneyRunner, POsListGenerated, POsObjectPageGenerated, POItemsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('cutomer/po/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThePOsListGenerated: POsListGenerated,
			onThePOsObjectPageGenerated: POsObjectPageGenerated,
			onThePOItemsObjectPageGenerated: POItemsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

