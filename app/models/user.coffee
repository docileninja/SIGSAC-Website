mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

userSchema = mongoose.Schema {
  local : {
    email: String
    password: String
  }
}

userSchema.methods.generateHash = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync 8, null

userSchema.methods.validPassword = (password) ->
  return bcrypt.compareSync password, this.local.password

module.exports = mongoose.model "User", userSchema