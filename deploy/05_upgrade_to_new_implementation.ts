import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer, proxyOwner} = await bre.getNamedAccounts();
  const {execute, deploy} = deployments;
  const newImplementation = await deployments.get('NewImplementation');
  await execute(
    'ImplementationConfigurationRegistry',
    {from: proxyOwner},
    'setImplementation',
    newImplementation.address
  );
  await execute('ImplementationConfiguration', {from: proxyOwner}, 'destroy', proxyOwner);
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
func.dependencies = [
  'NewImplementation',
  'Proxy',
  'ImplementationConfiguration',
  'ImplementationConfigurationRegistry',
];
