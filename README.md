# CI Monitor Demo Pipeline

這個專案的唯一目的是快速產生大量的 GitHub Actions pipeline runs 和 logs，作為 CI/CD 監控工具開發的練習數據來源。

## 🎯 專案目標

提供多種類型的 GitHub Actions workflows，快速產生足夠的 pipeline 執行記錄和 logs 供練習使用。

## 📋 Pipeline 類型

### 1. 🟢 Basic Pipeline - 基礎成功流程

- 文件：`ci-basic.yml`
- 觸發：Push 到 main、手動觸發
- 執行：build + test jobs

### 2. 🔴 Failure Pipeline - 固定失敗

- 文件：`ci-failure.yml`
- 觸發：手動觸發
- 執行：故意 exit 1 失敗

### 3. 🎲 Random Pipeline - 隨機成功/失敗

- 文件：`ci-random.yml`
- 觸發：手動觸發
- 執行：預設 50% 機率成功（可透過參數調整成功率）

### 4. ⏰ Scheduled Pipeline - 定期執行

- 文件：`ci-scheduled.yml`
- 觸發：每 10 分鐘自動執行 + 手動觸發
- 執行：固定成功，產生定期數據

### 5. ⏳ Long Running Pipeline - 較長執行時間

- 文件：`ci-long-running.yml`
- 觸發：手動觸發
- 執行：3 步驟各 sleep 5 秒

### 6. 🔄 Matrix Pipeline - 矩陣構建

- 文件：`ci-matrix.yml`
- 觸發：手動觸發
- 執行：Node.js 18, 20 並行測試

## 🚀 快速產生數據

```bash
# 1. Clone 專案
git clone https://github.com/imrredrum/ci-monitor-demo-pipeline.git
cd ci-monitor-demo-pipeline

# 2. 設定 GitHub CLI (如果尚未設定)
gh auth login

# 3. 快速觸發所有 pipelines 產生數據
make trigger-all

# 4. 批量產生大量隨機數據（預設 20 個，80% 成功率）
make generate-data

# 5. 批量產生指定數量的隨機數據
make generate-data-50  # 產生 50 個

# 6. 查看產生的 pipeline runs
make list-runs
```

## 📁 專案結構

```
ci-monitor-demo-pipeline/
├── .github/workflows/
│   ├── ci-basic.yml
│   ├── ci-failure.yml
│   ├── ci-long-running.yml
│   ├── ci-matrix.yml
│   ├── ci-random.yml
│   └── ci-scheduled.yml
├── .trigger-timestamp   # 用於 push 觸發的時間戳文件
├── .gitignore
├── Makefile             # 快速觸發命令
└── README.md
```

## 🔧 可用命令

```bash
# 觸發所有手動 pipelines（不包含 scheduled）
make trigger-all

# 分別觸發
make trigger-basic
make trigger-fail
make trigger-random    # 50% 成功，50% 失敗
make trigger-scheduled # 注意：此 pipeline 會自動每 10 分鐘執行
make trigger-long
make trigger-matrix

# 批量產生大量數據（使用 80% 成功率）
make generate-data     # 預設產生 20 個 random runs (80% 成功)
make generate-data-50  # 產生 50 個 random runs (80% 成功)

# 查看 runs
make list-runs

# 推送觸發 basic pipeline（會創建時間戳文件）
make push-main
```

---

**🎯 此專案僅用於快速產生大量 GitHub Actions pipeline runs 和 logs 作為練習數據。**
