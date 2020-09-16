import {expect} from './chai-setup';
import {ethers, deployments, getUnnamedAccounts} from '@nomiclabs/buidler';

describe('ProxyWithNoStorage', function () {
  it('should say hello world', async function () {
    await deployments.fixture(['Proxy']);
    const proxy = await ethers.getContract('Proxy');
    const message = await proxy.callStatic.sayHello();
    expect(message).to.equal('Hello World');
  });

  it('post upgrade: should say hello new world', async function () {
    await deployments.fixture(['Upgrade']);
    const proxy = await ethers.getContract('Proxy');
    const message = await proxy.callStatic.sayHello();
    expect(message).to.equal('Hello New World');
  });
});
