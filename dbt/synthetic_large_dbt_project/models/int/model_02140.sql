{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00776') }},
        {{ ref('model_00858') }},
        {{ ref('model_01373') }}
)
select id, 'model_02140' as name from sources
