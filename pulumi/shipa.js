import * as pulumi from "@pulumi/pulumi";
import * as shipa from "@shipa-corp/pulumi";


const item = new shipa.Framework("shipa-framework", {
    framework: {
        name: "pulumi-framework-1",
        provisioner: "kubernetes",
        kubernetesNamespace: "existing-namespace",
        resources: {
            general: {
                setup: {
                    public: true,
                    default: false,
                },
                security: {
                    disableScan: true,
                    scanPlatformLayers: false,
                    ignoreComponents: ["apt", "bash", "..."],
                    ignoreCves: ["CVE-2020-27350", "CVE-2011-3374", "..."],
                },
                router: "traefik",
                appQuota: {
                    limit: "2",
                },
                plan: {
                    name: "shipa-plan",
                },
                access: {
                    appends: ["shipa-team"],
                },
                networkPolicy: {
                    ingress: {
                        policyMode: "allow-custom-rules-only",
                        customRules: [
                            {
                                id: "pm-fw",
                                enabled: true,
                                description: "framework block",
                                allowedApps: ["app1", "appx"],
                                allowedFrameworks: ["dev", "qa"],
                                ports: [{
                                    port: 8080,
                                    protocol: "TCP"
                                },
                                {
                                    port: 8081,
                                    protocol: "TCP",
                                }]
                            },
                        ]
                    },
                    egress: {
                        policyMode: "allow-all",
                    },
                    disableAppPolicies: false,
                    },
                containerPolicy: {
                    allowedHosts: ["docker.io/shipasoftware", "docker.io/shiparepo"],
                }
            }
        }
    }
});

export const frameworkName = item.framework.name;
