{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01660') }},
        {{ ref('model_02175') }},
        {{ ref('model_01893') }}
)
select id, 'model_02556' as name from sources
