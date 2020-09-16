import {BuidlerRuntimeEnvironment, DeployFunction} from '@nomiclabs/buidler/types';

const func: DeployFunction = async function (bre: BuidlerRuntimeEnvironment) {
  const {deployments} = bre;
  const {deployer} = await bre.getNamedAccounts();
  const {deploy} = deployments;
  await deploy('NewImplementation', {
    from: deployer,
    log: true,
  });
};
export default func;
func.tags = ['NewImplementation'];
