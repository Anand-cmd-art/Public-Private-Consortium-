'use strict';

const { Contract } = require('fabric-contract-api');

class CSPVerificationContract extends Contract {

    // Initialize ledger with sample CSP records.
    async initLedger(ctx) {
        console.info('=== Initializing Ledger ===');
        const csps = [
            { id: 'CSP1', name: 'CloudProviderOne', verified: false },    // these are the values where the verified values are gonna be stored from the public contracts.
            { id: 'CSP2', name: 'CloudProviderTwo', verified: true }
        ];
        for (const csp of csps) {
            await ctx.stub.putState(csp.id, Buffer.from(JSON.stringify(csp)));
            console.info(`Added <--> ${csp.id}`);
        }
    }

    // Query a CSP by its ID.
    async queryCSP(ctx, id) {
        const cspAsBytes = await ctx.stub.getState(id);
        if (!cspAsBytes || cspAsBytes.length === 0) {
            throw new Error(`CSP ${id} does not exist`);
        }
        return cspAsBytes.toString();
    }

    // Create a new CSP record.
    async createCSP(ctx, id, name, verified) {
        const exists = await ctx.stub.getState(id);
        if (exists && exists.length > 0) {
            throw new Error(`CSP ${id} already exists`);
        }
        const csp = { id, name, verified: JSON.parse(verified) };
        await ctx.stub.putState(id, Buffer.from(JSON.stringify(csp)));
        return JSON.stringify(csp);
    }

    // Update an existing CSP record.
    async updateCSP(ctx, id, name, verified) {
        const cspAsBytes = await ctx.stub.getState(id);
        if (!cspAsBytes || cspAsBytes.length === 0) {
            throw new Error(`CSP ${id} does not exist`);
        }
        const csp = JSON.parse(cspAsBytes.toString());
        csp.name = name;
        csp.verified = JSON.parse(verified);
        await ctx.stub.putState(id, Buffer.from(JSON.stringify(csp)));
        return JSON.stringify(csp);
    }

    // Delete an existing CSP record.
    async deleteCSP(ctx, id) {
        const cspAsBytes = await ctx.stub.getState(id);
        if (!cspAsBytes || cspAsBytes.length === 0) {
            throw new Error(`CSP ${id} does not exist`);
        }
        await ctx.stub.deleteState(id);
    }
}

module.exports = CSPVerificationContract;
