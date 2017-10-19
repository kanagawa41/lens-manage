# 各サービスの基底モジュール
module BaseService extend self

  # TODO: pidの制御をしようとしたが志半ばで諦めた
  LOCKFILE = "#{Rails.root}#{Rails.application.config.common.pid[:lock_file]}".freeze

  # プロセス実行時
  def begin_ps(shell_str)
    # ファイルチェック
    if File.exist?(LOCKFILE)
      # pidのチェック
      pid = 0
      File.open(LOCKFILE, "r") do |f|
        pid = f.read.chomp!.to_i
      end
      if exist_process(pid)
        raise "既に起動中のプロセスがいます。"
      else
        end_ps
        raise "前のプロセスが最後まで実行されていませんでした。"
      end
    end

    pid = `#{shell_str} & echo $!`

    unless pid.present?
      raise "プロセスが正しく実行できていない。"
    end

    # LOCKファイル作成
    File.open(LOCKFILE, "w") do |f|
      # LOCK_NBのフラグもつける。もしぶつかったとしてもすぐにやめさせる。
      locked = f.flock(File::LOCK_EX | File::LOCK_NB)
      if locked
        f.puts pid
      else
        $logger.error("lock failed -> pid: #{pid}")
      end
    end
  end

  # 終了時のLOCKFILE削除
  def end_ps
    File.delete(LOCKFILE)
  end

  private

  # プロセスの存在チェック
  def exist_process(pid)
    begin
      gid = Process.getpgid(pid)
      return true
    rescue => ex
      puts ex
      return false
    end
  end
end