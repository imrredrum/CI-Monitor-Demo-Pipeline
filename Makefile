# CI Monitor Demo Pipeline - 快速產生 Pipeline 數據

help:
	@echo "快速產生 GitHub Actions Pipeline 數據"
	@echo ""
	@echo "觸發 Pipelines："
	@echo "  trigger-basic     - 觸發基礎成功 pipeline"
	@echo "  trigger-fail      - 觸發失敗 pipeline"
	@echo "  trigger-random    - 觸發隨機結果 pipeline"
	@echo "  trigger-scheduled - 觸發定期執行 pipeline"
	@echo "  trigger-long      - 觸發長時間執行 pipeline"
	@echo "  trigger-matrix    - 觸發矩陣構建 pipeline"
	@echo "  trigger-all       - 觸發所有 pipelines"
	@echo ""
	@echo "查看數據："
	@echo "  list-runs         - 列出最近的 workflow runs"
	@echo ""
	@echo "其他："
	@echo "  push-main         - 推送到 main 分支（觸發 basic pipeline）"

# 觸發 workflows
trigger-basic:
	gh workflow run ci-basic.yml

trigger-fail:
	gh workflow run ci-failure.yml

trigger-random:
	gh workflow run ci-random.yml

trigger-scheduled:
	@echo "⚠️  注意：此 pipeline 會每 10 分鐘自動執行"
	@echo "🚀 手動觸發 scheduled pipeline..."
	gh workflow run ci-scheduled.yml

trigger-long:
	gh workflow run ci-long-running.yml

trigger-matrix:
	gh workflow run ci-matrix.yml

trigger-all: trigger-basic trigger-fail trigger-random trigger-long trigger-matrix
	@echo "✅ 已觸發所有手動 pipelines，等待數據生成..."
	@echo "💡 注意：scheduled pipeline 會自動每 10 分鐘執行，無需手動觸發"

# 查看 runs
list-runs:
	gh run list --limit 20

# 推送觸發
push-main:
	@echo "📝 創建時間戳文件以觸發 pipeline..."
	echo "Pipeline triggered at: $(shell date)" > .trigger-timestamp
	git add .trigger-timestamp
	git commit -m "trigger pipeline at $(shell date '+%Y-%m-%d %H:%M:%S')" || true
	git push origin main
	@echo "🚀 推送完成，basic pipeline 應該會被觸發"

.PHONY: help trigger-basic trigger-fail trigger-random trigger-scheduled trigger-long trigger-matrix trigger-all list-runs push-main
