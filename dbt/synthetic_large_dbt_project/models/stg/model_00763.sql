{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00265') }},
        {{ ref('model_00170') }},
        {{ ref('model_00380') }}
)
select id, 'model_00763' as name from sources
