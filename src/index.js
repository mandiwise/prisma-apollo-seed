require("dotenv").config();

const { ApolloServer } = require("apollo-server-express");
const express = require("express");
const { importSchema } = require("graphql-import");
const path = require("path");

const { prisma } = require("./generated/prisma-client");
const resolvers = require("./resolvers.js");

const typeDefs = importSchema(path.join(__dirname, "./schema.graphql"));

const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: {
    prisma
  }
});

const app = express();
server.applyMiddleware({ app });

app.listen({ port: 4000 }, () =>
  console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`)
);
