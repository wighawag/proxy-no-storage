import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer} = await bre.getNamedAccounts();
  const {deploy} = deployments;
  await deploy('InitialImplementation', {
    from: deployer,
    log: true,
    deterministicDeployment: true,
  });
};
export default func;
func.tags = ['InitialImplementation'];
