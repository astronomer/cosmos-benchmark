{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02005') }},
        {{ ref('model_01941') }},
        {{ ref('model_01781') }}
)
select id, 'model_02297' as name from sources
