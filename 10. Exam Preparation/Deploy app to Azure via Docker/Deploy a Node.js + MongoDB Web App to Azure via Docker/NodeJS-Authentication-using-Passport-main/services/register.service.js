const mongoose = require('mongoose')
const User = mongoose.model('User')
const bcrypt = require('bcrypt')

module.exports = async (req,res) => {
    try{
        const ifExists = await User.findOne({ username:req.body.username })
        if (ifExists)
            return res.send('<h1>Username already exists.</h1><p>Please <a href="/register">register</a> with another username</p>');
        const user = new User({
            username:req.body.username,
            password: bcrypt.hashSync(req.body.password,bcrypt.genSaltSync(10))
        })
        await user.save()
        return res.redirect('/login');
    }catch(err){
        console.log(err)
        return res.status(500).json('Internal Server Error')
    }
}