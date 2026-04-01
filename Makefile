# CI Monitor Demo Pipeline - 快速產生 Pipeline 數據

help:
	@echo "快速產生 GitHub Actions Pipeline 數據"
	@echo ""
	@echo "觸發 Pipelines："
	@echo "  trigger-basic     - 觸發基礎成功 pipeline"
	@echo "  trigger-fail      - 觸發失敗 pipeline"
	@echo "  trigger-random    - 觸發隨機結果 pipeline (50% 成功)"
	@echo "  trigger-scheduled - 觸發定期執行 pipeline"
	@echo "  trigger-long      - 觸發長時間執行 pipeline"
	@echo "  trigger-matrix    - 觸發矩陣構建 pipeline"
	@echo "  trigger-all       - 觸發所有手動 pipelines"
	@echo ""
	@echo "批量產生數據："
	@echo "  generate-data     - 批量觸發 random pipelines (預設 20 個，80% 成功)"
	@echo "  generate-data-N   - 批量觸發 N 個 random pipelines (例: make generate-data-50，80% 成功)"
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
	@echo "🎲 觸發隨機結果 pipeline (50% 成功率)..."
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

# 批量產生數據
generate-data:
	@echo "🚀 開始批量觸發 20 個 random pipelines (80% 成功率)..."
	@for i in $$(seq 1 20); do \
		echo "觸發第 $$i 個 random pipeline..."; \
		gh workflow run ci-random.yml -f success_rate=80; \
		sleep 2; \
	done
	@echo "✅ 已觸發 20 個 random pipelines，預期約 16 個成功，4 個失敗"

# 批量產生指定數量的數據
generate-data-%:
	@echo "🚀 開始批量觸發 $* 個 random pipelines (80% 成功率)..."
	@for i in $$(seq 1 $*); do \
		echo "觸發第 $$i 個 random pipeline..."; \
		gh workflow run ci-random.yml -f success_rate=80; \
		sleep 2; \
	done
	@total=$*; \
	expected_success=$$((total * 80 / 100)); \
	expected_failure=$$((total - expected_success)); \
	echo "✅ 已觸發 $* 個 random pipelines，預期約 $$expected_success 個成功，$$expected_failure 個失敗"

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

.PHONY: help trigger-basic trigger-fail trigger-random trigger-scheduled trigger-long trigger-matrix trigger-all generate-data list-runs push-main
