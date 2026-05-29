{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01205') }}
)
select id, 'model_02170' as name from sources
