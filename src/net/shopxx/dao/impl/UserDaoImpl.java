/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import org.springframework.stereotype.Repository;

import net.shopxx.dao.UserDao;
import net.shopxx.entity.User;

/**
 * Dao用户
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class UserDaoImpl extends BaseDaoImpl<User, Long> implements UserDao {

}