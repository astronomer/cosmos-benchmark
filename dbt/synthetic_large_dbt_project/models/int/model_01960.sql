{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00776') }}
)
select id, 'model_01960' as name from sources
