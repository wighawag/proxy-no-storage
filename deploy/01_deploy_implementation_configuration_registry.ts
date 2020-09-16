import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer, proxyOwner} = await bre.getNamedAccounts();
  const {deploy} = deployments;
  const initialImplementation = await deployments.get('InitialImplementation');
  await deploy('ImplementationConfigurationRegistry', {
    from: deployer,
    args: [proxyOwner, initialImplementation.address],
    log: true,
  });
};
export default func;
func.tags = ['ImplementationConfigurationRegistry'];
func.dependencies = ['InitialImplementation'];
