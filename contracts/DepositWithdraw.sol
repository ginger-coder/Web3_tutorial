// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract DepositWithdraw {
    // map结构用于存储用户存款金额 key 为用户地址 value 为存款金额 Wei
    mapping(address => uint256) public BankWarehouse;

    // 用于记录用户上次存款的时间戳
    mapping(address => uint256) public LastDepositTime;

    // 存款年化利率
    uint256 public InterestRate = 0.05 * 1e18;

    // 一年的秒数
    uint256 public OneYearTimestamp = 365 * 24 * 60 * 60;

    // 每秒的存款收益
    uint256 public DepositInterest = InterestRate / OneYearTimestamp;

    /**
     * 用户存款
     * 存款必须为ETH payable类型
     * external 修饰符用于限制函数只能在外部合约或用户调用
     */
    function deposit() external payable {
        require(msg.value > 0, "Amount must be greater than 0");

        if (BankWarehouse[msg.sender] > 0) {
            // 计算用户存款时间差
            uint256 timeDiff = block.timestamp - LastDepositTime[msg.sender];
            // 计算用户存款收益
            uint256 interest = (BankWarehouse[msg.sender] *
                DepositInterest *
                timeDiff) / 1e18;
            // 将存款收益加到用户存款金额上
            BankWarehouse[msg.sender] += interest;
        }

        // 更新用户存款金额
        BankWarehouse[msg.sender] += msg.value;
        // 更新用户存款时间戳
        LastDepositTime[msg.sender] = block.timestamp;
    }

    /**
     * 用户取款
     * external 修饰符用于限制函数只能在外部合约或用户调用
     */
    function withdraw(uint256 amount) external {
        // 取款金额必须大于0
        require(amount > 0, "withdraw amount must be greater than 0");

        // 先计算利息，再进与取款金额比较
        // 存款时间内产生的利息
        uint256 interest = (BankWarehouse[msg.sender] *
            DepositInterest *
            (block.timestamp - LastDepositTime[msg.sender])) / 1e18;
        // 将利息加到存款金额上
        BankWarehouse[msg.sender] += interest;

        // 账户余额必须大于等于取款金额
        require(
            BankWarehouse[msg.sender] >= amount,
            "insufficient balance"
        );
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
        // 计算总利息
        uint256 interest = (amount * DepositInterest * (block.timestamp - LastDepositTime[msg.sender])) / 1e18;
        // 总存款金额 = 存款金额 + 存款利息
        uint256 totalAmount = amount + interest;
        // 清空用户存款
        BankWarehouse[msg.sender] = 0;
        // 将存款金额转给用户
        payable(msg.sender).transfer(totalAmount);
    }
}