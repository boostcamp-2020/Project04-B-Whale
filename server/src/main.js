import { Application } from './Application';

async function main() {
    const app = new Application();
    await app.initialize();
    await app.listen(process.env.PORT || 5000);
}

main();
