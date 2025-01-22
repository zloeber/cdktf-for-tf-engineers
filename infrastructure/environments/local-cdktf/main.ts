import { Construct } from "constructs";
import { App, TerraformOutput, LocalBackend, TerraformStack } from "cdktf";
import * as K8SKindCluster from "./.gen/modules/modules/k8s-kind-cluster";
import { ClusterStack, ClusterStackProps } from "./clusterconfig";
import * as config from "./config.json";

class BootstrapStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new LocalBackend(this, {
      path: config.infrastructure.state,
    });
    /*Terraform Variables are not always the best fit for getting inputs in the context of Terraform CDK.
You can read more about this at https://cdk.tf/variables*/
    const cluster1 = new K8SKindCluster.K8SKindCluster(this, "cluster1", {
      clusterConfigPath: config.cluster1.kubeconfig,
      clusterName: "cluster1",
    });
    new TerraformOutput(this, "kubeconfig_path", {
      value: cluster1.clusterConfigPathOutput,
    });
  }
}

const app = new App();
new BootstrapStack(app, "infrastructure");

const cluster1 = <ClusterStackProps>{
  clusterName: "cluster1",
  clusterState: config.cluster1.state,
  env: config.env,
  kubeconfig: config.cluster1.kubeconfig,
  secretsPath: config.cluster1.secrets_path,
  helmValues: config.cluster1.helm_values,
};

new ClusterStack(app, "cluster1", cluster1);
app.synth();
