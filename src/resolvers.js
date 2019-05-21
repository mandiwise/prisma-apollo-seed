module.exports = {
  Query: {
    async users(_, args, context) {
      return await context.prisma.users();
    },

    async user(_, { where }, context) {
      return await context.prisma.user(where);
    }
  },

  Mutation: {
    async createUser(_, { data }, context) {
      return await context.prisma.createUser(data);
    },

    async deleteUser(_, { where }, context) {
      return await context.prisma.deleteUser(where);
    },

    async updateUser(_, { data, where }, context) {
      return await context.prisma.updateUser({ data, where });
    }
  }
};
