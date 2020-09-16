import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer} = await bre.getNamedAccounts();
  const {deploy} = deployments;
  const implementationConfiguration = await deployments.get('ImplementationConfiguration');
  const implementationConfigurationRegistry = await deployments.get('ImplementationConfigurationRegistry');
  const proxyWithNoStorage = await deploy('ProxyWithNoStorage', {
    from: deployer,
    args: [implementationConfiguration.address, implementationConfigurationRegistry.address],
    log: true,
  });
  const implementation = await deployments.get('InitialImplementation');
  await deployments.save('Proxy', {
    ...proxyWithNoStorage,
    abi: implementation.abi,
  });
};
export default func;
func.tags = ['Proxy'];
func.dependencies = ['InitialImplementation', 'ImplementationConfiguration'];
