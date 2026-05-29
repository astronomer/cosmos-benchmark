{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00059') }}
)
select id, 'model_00760' as name from sources
