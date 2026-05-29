{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00776') }},
        {{ ref('model_01128') }}
)
select id, 'model_02168' as name from sources
