import { Application } from './Application';

async function main() {
    const app = new Application();

    process.on('SIGINT', async () => {
        await app.close();
        process.exit(0);
    });

    await app.initialize();
    await app.listen(process.env.PORT || 5000);

    if (process?.send ?? false) {
        process.send('ready');
    }
}

main();
