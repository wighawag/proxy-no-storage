import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer} = await bre.getNamedAccounts();
  const {deploy} = deployments;
  const implementationConfigurationRegistry = await deployments.get('ImplementationConfigurationRegistry');
  await deploy('ImplementationConfiguration', {
    from: deployer,
    args: [implementationConfigurationRegistry.address],
    log: true,
    deterministicDeployment: true,
  });
};
export default func;
func.tags = ['Upgrade'];
func.dependencies = ['UpgradeSetup'];
