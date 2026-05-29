{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01059') }},
        {{ ref('model_01361') }}
)
select id, 'model_02050' as name from sources
