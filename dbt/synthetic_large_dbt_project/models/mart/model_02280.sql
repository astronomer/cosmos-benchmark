{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01877') }}
)
select id, 'model_02280' as name from sources
