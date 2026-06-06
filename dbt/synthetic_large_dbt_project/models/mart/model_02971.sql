{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01854') }},
        {{ ref('model_01637') }},
        {{ ref('model_01559') }}
)
select id, 'model_02971' as name from sources
