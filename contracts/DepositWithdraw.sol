// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract DepositWithdraw {
    // map结构用于存储用户存款金额 key 为用户地址 value 为存款金额
    mapping (address => uint256) BankWarehouse;

    /**
     * 用户存款
     * 存款必须为ETH payable类型
     * external 修饰符用于限制函数只能在外部合约或用户调用 
     */
    function deposit() external payable {
        require(msg.value > 0, "deposit amount must be greater than 0");
        BankWarehouse[msg.sender] += msg.value;
    }

    /**
     * 用户取款
     * external 修饰符用于限制函数只能在外部合约或用户调用
     */
    function withdraw(uint256 amount) external{
        // 取款金额必须大于0
        require(amount > 0, "withdraw amount must be greater than 0");
        // 账户余额必须大于等于取款金额
        require(BankWarehouse[msg.sender] >= amount, "insufficient balance");
        BankWarehouse[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    /**
     * 仅限有存款的用户调用，一次性提取所有存款
     */

    function ownerWithdraw() external {
        // 用户必须有存款
        uint256 amount = BankWarehouse[msg.sender];
        require(amount > 0, "no deposit found");

        // 清空用户存款
        BankWarehouse[msg.sender] = 0;
        // 将存款金额转给用户
        payable(msg.sender).transfer(amount);
    }
}