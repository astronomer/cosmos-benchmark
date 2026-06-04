{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01205') }},
        {{ ref('model_01283') }},
        {{ ref('model_00879') }}
)
select id, 'model_02169' as name from sources
