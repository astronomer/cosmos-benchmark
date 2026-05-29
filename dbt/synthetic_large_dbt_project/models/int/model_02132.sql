{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00928') }},
        {{ ref('model_00900') }},
        {{ ref('model_01382') }}
)
select id, 'model_02132' as name from sources
