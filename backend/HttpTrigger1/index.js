const { CosmosClient } = require("@azure/cosmos");

// Use your Cosmos DB connection string as an environment variable for security
const connectionString = process.env.COSMOS_DB_CONNECTION_STRING;

const client = new CosmosClient(connectionString);

const databaseId = "VisitorDB";
const containerId = "CountContainer";
const itemId = "visitor-count"; // the document id for the counter

module.exports = async function (context, req) {
  try {
    const container = client.database(databaseId).container(containerId);

    // Try to read the visitor count document
    let { resource: item } = await container.item(itemId, itemId).read().catch(() => null);

    if (!item) {
      // If no document exists, create one with count = 1
      item = { id: itemId, count: 1 };
      await container.items.create(item);
    } else {
      // If document exists, increment count and update it
      item.count++;
      await container.items.upsert(item);
    }

    context.res = {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*" // Allow CORS for your frontend
      },
      body: {
        count: item.count
      }
    };
  } catch (error) {
    context.log.error("Error updating visitor count:", error);
    context.res = {
      status: 500,
      body: { error: error.message }
    };
  }
};


// kk