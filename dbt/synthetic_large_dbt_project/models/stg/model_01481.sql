{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00331') }}
)
select id, 'model_01481' as name from sources
