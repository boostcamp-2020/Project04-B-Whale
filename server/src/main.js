import { Application } from './Application';
import { ApplicationFactory } from './ApplicationFactory';

async function main() {
    const app = await ApplicationFactory.create();
    await app.listen(process.env.PORT || 3000);
    console.log(`Server listening on ${process.env.PORT || 3000}`);
}

main();
