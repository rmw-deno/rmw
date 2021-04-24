const decoder = new TextDecoder();

export default async () => {
  const isWin = Deno.build.os === 'windows';
  const command = isWin ? 'ipconfig' : 'ifconfig';
  try {
    let ifconfig = await Deno.run({
      cmd: [command],
      stdout: 'piped',
    });

    const {
      success
    } = await ifconfig.status();
    if (!success) {
      throw new Error(`Subprocess ${command} failed to run`);
    }

    const raw = await ifconfig.output();
    const text = decoder.decode(raw);
    if (isWin) {
      const addrs = text.match(new RegExp('ipv4.+([0-9]+.){3}[0-9]+', 'gi'));
      await Deno.close(ifconfig.rid);
      return addrs;
    } else {
      const addrs = text.match(
        new RegExp('inet (addr:)?([0-9]*.){3}[0-9]*', 'g')
      );
      await Deno.close(ifconfig.rid);
      if (!addrs || !addrs.some((x) => !x.startsWith('inet 127'))) {
        throw new Error('Could not resolve your local adress.');
      };
      const result = [];
      for (let i of addrs) {
        let ip = i.slice(5);
        if (!ip.startsWith('127')) {
          result.push(ip);
        }
      }
      return result;
    }
  } catch (err) {
    console.log(err.message);
  }
};
