({
    doInit : function(component, event, helper) {

        var flow = component.find("leadFlow");

        if (flow) {
            flow.startFlow("Cadastro_Inteligente_de_Lead");
        }
    },

    handleStatusChange : function(component, event, helper) {

        var status = event.getParam("status");

        if (status === "FINISHED" || status === "FINISHED_SCREEN") {

            component.set("v.showSuccess", true);

            window.setTimeout(
                $A.getCallback(function() {

                    var navEvt =
                        $A.get("e.force:navigateToObjectHome");

                    if (navEvt) {

                        navEvt.setParams({
                            "scope": "Lead"
                        });

                        navEvt.fire();

                    } else {

                        window.location.href =
                            "/lightning/o/Lead/list";
                    }

                }),
                1800
            );
        }
    },

    handleClose : function(component, event, helper) {

        var navEvt =
            $A.get("e.force:navigateToObjectHome");

        if (navEvt) {

            navEvt.setParams({
                "scope": "Lead"
            });

            navEvt.fire();

        } else {

            window.location.href =
                "/lightning/o/Lead/list";
        }
    }
})