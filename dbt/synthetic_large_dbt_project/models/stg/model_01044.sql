{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00098') }},
        {{ ref('model_00460') }},
        {{ ref('model_00342') }}
)
select id, 'model_01044' as name from sources
